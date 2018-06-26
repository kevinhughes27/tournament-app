const App = {
  root: {
    flexGrow: 1
  }
};

const TopBar = {
  title: {
    flex: 1,
    color: "white"
  },
  menuButton: {
    color: "white",
    marginLeft: -12,
    marginRight: 20,
  },
};

const UserMenu = {};

const SideBar = {};

const NavItems = {
  list: {
    width: 250,
  }
};

const Loader = {
  container: {
    display: "flex",
    height: "92vh",
    justifyContent: "center",
    alignItems: "center"
  },
  spinner: {
    marginBottom: 80
  }
};

const BlankSlate = {
  container: {
    display: "flex",
    height: "92vh",
    justifyContent: "center",
    alignItems: "center"
  }
};

export {
  App,
  TopBar,
  UserMenu,
  SideBar,
  NavItems,
  Loader,
  BlankSlate
};
