import React, { Component } from "react";
import { Switch, Route, Link } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";
import "./App.css";

import AddUser from "./components/add-user.component";
import UsersList from "./components/users-list.component";

class App extends Component {
  render() {
    return (
      <div className="bg-warning bg-gradient">
        <nav className="navbar navbar-expand navbar-light bg-light">
          <a href="/users" className="navbar-brand">
            FanHub
          </a>
          <div className="navbar-nav mr-auto">
            <li className="nav-item">
              <Link to={"/users"} className="nav-link">
               Users
              </Link>
            </li>
            <li className="nav-item">
              <Link to={"/add"} className="nav-link">
                Add
              </Link>
            </li>
          </div>
        </nav>

        <div className="container mt-3">
          <h2>Welcome to FanHub CRUD Operations</h2>
          <Switch>
            <Route exact path={["/", "/users"]} component={UsersList} />
            <Route exact path="/add" component={AddUser} />
          </Switch>
        </div>
      </div>
    );
  }
}

export default App;
