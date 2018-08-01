const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const args = process.argv.slice(2);
const artifactDirectory = './src/generated';

/* Compile Relay Queries */
const compiler = spawn('relay-compiler',
  [
    '--src', './src',
    '--schema', '../../app/graphql/schema.graphql',
    '--language', 'typescript',
    '--artifactDirectory', artifactDirectory,
    ...args
  ]
);

compiler.stdout.on('data', data => {
  let compilerFinished = data.toString() === "Watching for changes to ts/tsx...\n";
  if (compilerFinished) { exportTypes(); }
  console.log(`${data}`);
});

compiler.stderr.on('data', data => {
  console.log(`${data}`);
});

compiler.on('close', code => {
  exportTypes();
});

/* Export Relay Types Globally */
function exportTypes() {
  console.log("Exporting types to ./types/generated.d.ts\n");

  fs.readdir(artifactDirectory, function(err, files) {
    if (err) {
      console.error('Could not list the directory.', err);
      process.exit(1);
    }

    let types = [];

    files.forEach(function(file) {
      const filePath = path.join(artifactDirectory, file);
      const generatedCode = fs.readFileSync(filePath).toString();
      let typeDefs = locations(generatedCode);
      let typeEnds = endings(typeDefs, generatedCode);

      // console.log(typeDefs);
      // console.log(typeEnds);

      for (let i = 0; i < typeDefs.length; i++) {
        let startIdx = typeDefs[i] + 7; // remove 'export'
        let endIdx = typeEnds[i];
        let type = generatedCode.slice(startIdx, endIdx);
        types.push(type);
      }
    });

    fs.writeFileSync('./types/generated.d.ts', types.join("\n"));
  });

  function locations(code){
    let a=[], i=-1;
    while((i=code.indexOf("export type",i+1)) >= 0) a.push(i);
    return a;
  }

  function endings(starts, code) {
    let a=[];
    starts.forEach(function(start) {
      let searchString = code.substring(start);

      let oneLiner = searchString.search(/= {};/g);
      if (oneLiner !== -1) {
        a.push(start + oneLiner + 6);
      } else {
        let closeBraceIdx = searchString.search(/^}/gm)
        let endLineIdx = searchString.substring(closeBraceIdx).indexOf("\n");
        a.push(start + closeBraceIdx + endLineIdx + 1);
      }
    });
    return a;
  }
}
