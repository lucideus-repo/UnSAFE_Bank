import React, { Fragment } from "react";

import PropTypes from "prop-types";

import Header from "./Header";
import Sidebar from "./Sidebar";
import { ThemeState } from "../../store/ReduxState";
import { bindActionCreators, Dispatch } from "redux";
import themeSlice from "../../slices/ThemeSlice";
import { RouteComponentProps, withRouter } from "react-router-dom";
import { connect } from "react-redux";
import clsx from "clsx";
interface Props extends RouteComponentProps<any> {
  children: PropTypes.ReactNodeLike;
  theme: ThemeState;
}

const LeftSidebar = ({ children, theme }: Props) => {
  return (
    <Fragment>
      <div
        className={clsx("app-wrapper", {
          "app-sidebar-mobile-open": theme.sidebarToggleMobile,
          "app-sidebar-fixed": true,
          "app-header-fixed": true
        })}
      >
        <div>
          <Sidebar />
        </div>
        <div className="app-main">
          <Header />
          <div className="app-content">
            <div className="app-content--inner">
              <div className="app-content--inner__wrapper">{children}</div>
            </div>
          </div>
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
      handleCurrentView: themeSlice.actions.setSidebarToggleMobile
    },
    dispatch
  );
};

export default withRouter(
  connect(mapStateToProps, mapDispatchToProps)(LeftSidebar)
);
