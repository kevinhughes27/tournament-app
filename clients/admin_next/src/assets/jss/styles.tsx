const App = {
  root: {
    flexGrow: 1,
    height: '100%',
  }
};

const TopBar = {
  title: {
    flex: 1,
    color: 'white'
  },
  menuButton: {
    color: 'white',
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

const BlankSlate = {
  container: {
    display: 'flex',
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center'
  },
  item: {
    height: 100
  }
}

export {
  App,
  TopBar,
  UserMenu,
  SideBar,
  NavItems,
  BlankSlate
};
