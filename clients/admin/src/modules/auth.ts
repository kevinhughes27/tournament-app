import cookies from "browser-cookies";
import decode from "jwt-decode";
import client from "./apollo";

const domain = () => {
  const hostname = window.location.hostname;
   if (hostname === "localhost") {
    return hostname;
  } else {
    const subdomainIdx = hostname.indexOf(".");
    return hostname.slice(subdomainIdx)
  }
}

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
      return response.status === 201
        ? response.json()
        : Promise.reject("Invalid username or password");
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

  setToken = (jwt: string) => {
    cookies.set('jwt', jwt, { domain: domain() });
  }

  getToken = () => {
    return cookies.get("jwt");
  }

  logout = () => {
    cookies.erase('jwt', { domain: domain() });
    client.resetStore();
  }
}

const auth = new Auth();

export default auth;
