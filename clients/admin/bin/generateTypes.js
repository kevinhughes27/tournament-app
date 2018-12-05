const fs = require('fs');
const { spawn } = require('child_process');

const args = process.argv.slice(2);
const artifactPath = './src/generated.ts';

/* Generate Types */
console.log("Generating Graphql Types");
const generator = spawn('node_modules/apollo/bin/run',
  [
    'client:codegen',
    artifactPath,
    '--localSchemaFile', '../../app/graphql/schema.graphql',
    '--includes', 'src/**/*.tsx',
    '--tagName', 'gql',
    '--target', 'typescript',
    '--addTypename',
    '--outputFlat',
    ...args
  ]
);

if (args[0] == '--watch') {
  generator.stdout.on('data', data => {
    const finished = /wrote \d+ files \[completed\]/.test(data.toString());

    if (finished) {
      fs.watchFile(artifactPath, function(curr, prev){
        exportTypes();
      });
    }
  });
} else {
  generator.on('close', code => {
    exportTypes();
  });
}

/* Export Types Globally */
function exportTypes() {
  console.log("Exporting types to ./types/generated.d.ts");
  let generatedCode = fs.readFileSync(artifactPath).toString();

  generatedCode = generatedCode.replace(/export interface/g, "type");
  generatedCode = generatedCode.replace(/{\n/g, "= {\n");

  fs.writeFileSync('./types/generated.d.ts', generatedCode);
}
