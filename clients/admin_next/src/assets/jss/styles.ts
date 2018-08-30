import amber from "@material-ui/core/colors/amber";
import { Theme, createStyles } from "@material-ui/core/styles";

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

const Modal = (theme: Theme) => createStyles({
  paper: {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: `translate(-50%, -50%)`,
    width: theme.spacing.unit * 50,
    backgroundColor: theme.palette.background.paper,
    boxShadow: theme.shadows[5],
    padding: theme.spacing.unit * 4,
  },
  title: {
    display: "flex",
    justifyContent: "space-between",
    alignItems: "center"
  }
});

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

const ActionMenu = (theme: Theme) => createStyles({
  fab: {
    position: "fixed",
    bottom: theme.spacing.unit * 2,
    right: theme.spacing.unit * 2,
  }
});

const SubmitButton = (theme: Theme) => createStyles({
  fab: {
    position: "fixed",
    bottom: theme.spacing.unit * 2,
    right: theme.spacing.unit * 2,
    zIndex: 1000,
  },
  inline: {
    marginTop: 20,
    float: "right"
  },
  disabled: {
    backgroundColor: "rgba(189, 189, 189, 0.8) !important"
  }
});

const ErrorBanner = {
  warning: {
    backgroundColor: amber[700]
  },
  icon: {
    fontSize: 20,
    opacity: 0.9,
    marginRight: 10
  },
  message: {
    display: "flex",
    alignItems: "center",
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
  Modal,
  BlankSlate,
  Breadcrumbs,
  ActionMenu,
  SubmitButton,
  ErrorBanner
};
