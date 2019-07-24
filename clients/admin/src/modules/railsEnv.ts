export default () => {
  return process.env.REACT_APP_RAILS_ENV || 'development';
};
