import React, { Fragment } from "react";
import clsx from "clsx";
import { Button } from "reactstrap";
import handleSignOutThunk from "../../thunks/Authentication/handleSignOutThunk";
import { connect } from "react-redux";
import { RouteComponentProps, withRouter } from "react-router-dom";

import { ThemeState } from "../../store/ReduxState";
import { bindActionCreators, Dispatch } from "redux";
import themeSlice from "../../slices/ThemeSlice";
import routes from "../../routes";

interface Props extends RouteComponentProps<any> {
  handleSignOut: (args: { token: string }) => void;
  theme: ThemeState;
  handleCurrentView: (payload: boolean) => void;
}

let Header = ({ handleSignOut, theme, handleCurrentView }: Props) => {
  let userData = JSON.parse(localStorage.getItem("userData")!);

  let onClickSignOut = (payload: string) => {
    handleSignOut({
      token: payload
    });
  };

  return (
    <Fragment>
      <div
        className={clsx("app-header", {
          "app-header--shadow": true
        })}
      >
        <div className="app-header--pane">
          <button
            className={clsx(
              "navbar-toggler hamburger hamburger--elastic toggle-mobile-sidebar-btn",
              { "is-active": theme.sidebarToggleMobile }
            )}
            onClick={() => handleCurrentView(!theme.sidebarToggleMobile)}
          >
            <span className="hamburger-box">
              <span className="hamburger-inner" />
            </span>
          </button>
        </div>
        <div className="app-header--pane">
          <Button
            color="vicious-stance"
            className="ml-3 mr-3"
            size="sm"
            href={routes.app.user.userProfile}
          >
            My Account
          </Button>

          <Button
            outline
            size="sm"
            color="vicious-stance"
            className="transition-none"
            onClick={(e) => onClickSignOut(userData.token)}
          >
            Sign out
          </Button>
        </div>
      </div>
    </Fragment>
  );
};
const mapStateToProps = (state: { theme: ThemeState }) => {
  return {
    theme: state.theme
  };
};
const mapDispatchToProps = (dispatch: Dispatch) => {
  return bindActionCreators(
    {
      handleSignOut: handleSignOutThunk,
      handleCurrentView: themeSlice.actions.setSidebarToggleMobile
    },
    dispatch
  );
};

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(Header));
