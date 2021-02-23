import clsx from "clsx";
import React, { Component, Fragment } from "react";
// @ts-ignore
import MetisMenu from "react-metismenu";
import PerfectScrollbar from "react-perfect-scrollbar";
import { connect } from "react-redux";
import { Link, RouteComponentProps, withRouter } from "react-router-dom";
import { bindActionCreators, Dispatch } from "redux";
import routes from "../../routes";
import themeSlice from "../../slices/ThemeSlice";
import { ThemeState } from "../../store/ReduxState";
// @ts-ignore
import RouterLink from "./ReactMetismenuRouterLink";
import LucideusLogo from "./SafeSecurityLogo";

interface Props extends RouteComponentProps<any> {
  theme: ThemeState;
  handleCurrentView: (payload: boolean) => void;
}

const sidebarMenuContent = [
  {
    label: "Dashboard",
    icon: "pe-7s-id",
    to: routes.app.dashboard
  },
  {
    label: "Account Statement",
    icon: "pe-7s-menu",
    to: routes.app.accountStatement
  },
  {
    label: "Beneficiary",
    icon: "pe-7s-users",
    content: [
      {
        label: "View Beneficiary",
        to: routes.app.beneficiary.viewBeneficiary
      },
      {
        label: "Add Beneficiary",
        to: routes.app.beneficiary.addBeneficiary
      }
    ]
  },
  {
    label: "Fund Transfer",
    icon: "pe-7s-cash",
    content: [
      {
        label: "Bank Transfer",
        to: routes.app.fundTransfer.bank
      },
      {
        label: "Wallet Transfer",
        to: routes.app.fundTransfer.wallet
      }
    ]
  },
  {
    label: "Loans",
    icon: "pe-7s-piggy",
    content: [
      {
        label: "Apply for Loan",
        to: routes.app.loan.apply
      },
      {
        label: "Applied Loans",
        to: routes.app.loan.appliedLoans
      }
    ]
  },
  {
    label: "Settings",
    icon: "pe-7s-settings",
    content: [
      {
        label: "Change Password",
        to: routes.app.changePassword
      }
    ]
  },
  {
    label: "Contact us",
    icon: "pe-7s-chat",
    to: routes.app.contactUs
  },
  {
    label: "About us",
    icon: "pe-7s-map-2",
    to: routes.app.about
  }
];
class SidebarHeader extends Component {
  render() {
    return (
      <Fragment>
        <div className="app-sidebar--header ">
          <Link
            to={routes.app.dashboard}
            title=""
            style={{ color: "white", padding: "30px" }}
          >
            <LucideusLogo />
          </Link>
        </div>
      </Fragment>
    );
  }
}

const SidebarMenu = () => {
  return (
    <Fragment>
      <PerfectScrollbar>
        <div className="sidebar-navigation">
          <div className="sidebar-header">
            <span>Navigation Menu</span>
          </div>

          <MetisMenu
            content={sidebarMenuContent}
            LinkComponent={RouterLink}
            activeLinkLocation
            iconNamePrefix=""
            noBuiltInClassNames={true}
            classNameItemActive="active"
            classNameIcon="sidebar-icon"
            iconNameStateVisible="sidebar-icon-indicator"
            iconNameStateHidden="sidebar-icon-indicator"
            classNameItemHasVisibleChild="submenu-open"
            classNameItemHasActiveChild="active"
            classNameStateIcon="pe-7s-angle-down"
          />
        </div>
      </PerfectScrollbar>
    </Fragment>
  );
};

let Sidebar = ({ theme, handleCurrentView }: Props) => {
  return (
    <Fragment>
      <div className="app-sidebar app-sidebar-fixed app-sidebar--dark">
        <SidebarHeader />
        <div className="app-sidebar--content">
          <SidebarMenu />
        </div>
      </div>

      <div
        onClick={() => handleCurrentView(!theme.sidebarToggleMobile)}
        className={clsx("app-sidebar-overlay", {
          "is-active": theme.sidebarToggleMobile
        })}
      />
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
  connect(mapStateToProps, mapDispatchToProps)(Sidebar)
);
