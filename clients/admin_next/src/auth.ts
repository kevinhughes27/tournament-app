import decode from "jwt-decode";

class Auth {
  login = (email: string, password: string) => {
    const headers = {
      "content-type": "application/json",
    };

    const body = JSON.stringify({
      auth: {
        email,
        password
      }
    });

    return fetch("/user_token", {
      method: "POST",
      headers,
      body
    }).then((response) => {
      return response.json();
    }).then((data) => {
      this.setToken(data.jwt);
      return Promise.resolve();
    });
  }

  loggedIn = () => {
    const token = this.getToken();
    return !!token && !this.isTokenExpired(token);
  }

  isTokenExpired = (token: string) => {
    try {
      const decoded = decode(token);

      if (decoded.exp < Date.now() / 1000) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      return false;
    }
  }

  setToken = (idToken: string) => {
    localStorage.setItem("id_token", idToken);
  }

  getToken = () => {
    return localStorage.getItem("id_token");
  }

  logout = () => {
    localStorage.removeItem("id_token");
  }
}

const auth = new Auth();

export default auth;