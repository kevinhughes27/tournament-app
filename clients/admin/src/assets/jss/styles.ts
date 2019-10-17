import amber from '@material-ui/core/colors/amber';
import { Theme, createStyles } from '@material-ui/core/styles';

const Login = {
  container: {
    display: 'flex',
    flexDirection: 'column' as 'column',
    height: '75vh',
    justifyContent: 'center',
    alignItems: 'center'
  },
  title: {
    flex: 1,
    color: 'white'
  },
  card: {
    maxWidth: 380
  },
  forgotLink: {
    color: '#039be5',
    textDecoration: 'none',
    display: 'block',
    paddingTop: 20
  },
  actions: {
    paddingBottom: 15,
    paddingLeft: 20,
    float: 'right' as 'right'
  },
  social: {
    display: 'flex',
    flexDirection: 'column' as 'column',
    justifyContent: 'space-around',
    paddingTop: 20,
    height: 115,
    maxWidth: 380,
    width: '100%'
  },
  google: {
    width: '100%',
    color: 'white',
    paddingRight: 30,
    backgroundColor: '#dd4b39',
    '&:hover': {
      backgroundColor: '#e47365'
    }
  },
  facebook: {
    width: '100%',
    color: 'white',
    backgroundColor: '#3b5998',
    '&:hover': {
      backgroundColor: '#4c70ba'
    }
  }
};

const Loader = {
  container: {
    display: 'flex',
    height: '92vh',
    justifyContent: 'center',
    alignItems: 'center'
  },
  spinner: {
    marginBottom: 80
  }
};

const Modal = (theme: Theme) =>
  createStyles({
    paper: {
      position: 'absolute',
      top: '50%',
      left: '50%',
      transform: `translate(-50%, -50%)`,
      width: 540,
      maxWidth: '90%',
      backgroundColor: theme.palette.background.paper,
      boxShadow: theme.shadows[5],
      padding: theme.spacing(4)
    },
    title: {
      display: 'flex',
      justifyContent: 'space-between',
      alignItems: 'center'
    }
  });

const ReportsBadge = {
  badge: {
    fontSize: 10,
    height: 18,
    width: 18,
    right: -20
  }
};

const BlankSlate = {
  container: {
    display: 'flex',
    height: '92vh',
    justifyContent: 'center',
    alignItems: 'center',
    textAlign: 'center' as 'center'
  }
};

const Breadcrumbs = {
  container: {
    paddingTop: 20,
    paddingLeft: 20
  },
  link: {
    textDecoration: 'none',
    '&:hover': {
      textDecoration: 'underline'
    },
    '&:visited': {
      color: 'rgba(0, 0, 0, 0.87)'
    }
  }
};

const ActionMenu = (theme: Theme) =>
  createStyles({
    fab: {
      position: 'fixed',
      bottom: theme.spacing(2),
      right: theme.spacing(2)
    }
  });

const FormButtons = (theme: Theme) =>
  createStyles({
    fab: {
      position: 'fixed',
      bottom: theme.spacing(2),
      right: theme.spacing(2),
      zIndex: 1000
    },
    inline: {
      marginTop: 20,
      float: 'right'
    },
    cancelButton: {
      lineHeight: '24px',
      color: 'white',
      textDecoration: 'none',
      marginRight: 10
    },
    cancelLink: {
      color: 'white',
      textDecoration: 'none'
    },
    deleteButton: {
      backgroundColor: '#F44336',
      marginRight: 10,
      '&:hover': {
        backgroundColor: '#E53935'
      }
    },
    disabled: {
      backgroundColor: 'rgba(189, 189, 189, 0.8) !important'
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
    display: 'flex',
    alignItems: 'center'
  }
};

export {
  Login,
  Loader,
  Modal,
  ReportsBadge,
  BlankSlate,
  Breadcrumbs,
  ActionMenu,
  FormButtons,
  ErrorBanner
};
