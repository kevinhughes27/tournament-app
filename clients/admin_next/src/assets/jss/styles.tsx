const Login = {
  container: {
    display: "flex",
    height: "75vh",
    justifyContent: "center",
    alignItems: "center"
  },
  title: {
    flex: 1,
    color: "white"
  },
  card: {
    maxWidth: 380
  },
  actions: {
    justifyContent: "flex-end"
  }
};

const Admin = {
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

const Breadcrumbs = {
  container: {
    paddingTop: 20,
    paddingLeft: 20,
  },
  link: {
    "textDecoration": "none",
    "&:hover": {
      textDecoration: "underline"
    },
    "&:visited": {
      color: "rgba(0, 0, 0, 0.87)"
    }
  }
};

export {
  Login,
  Admin,
  TopBar,
  UserMenu,
  SideBar,
  NavItems,
  Loader,
  BlankSlate,
  Breadcrumbs
};
