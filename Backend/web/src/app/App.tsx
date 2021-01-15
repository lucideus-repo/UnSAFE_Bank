import React from "react";
import "./assets/css/paper-dashboard.css";
import { BrowserRouter, Route, Switch } from "react-router-dom";
import "./assets/base.scss";
import "./App.scss";
import LoginPage from "./components/Pages/Authentication/LoginPage";
import DashboardPage from "./components/Pages/DashboardPage";
import SignUpPage from "./components/Pages/Authentication/SignUpPage";
import AccountStatementPage from "./components/Pages/AccountStatementPage";
import { library } from "@fortawesome/fontawesome-svg-core";
import UserProfilePage from "./components/Pages/UserProfilePage";
import EditUserPage from "./components/Pages/EditUserPage";
import ViewBeneficiaryPage from "./components/Pages/Beneficiary/ViewBeneficiaryPage";
import ForgotPasswordPage from "./components/Pages/Authentication/ForgotPasswordPage";
import { toast } from "react-toastify";
import LeftSidebar from "./components/Sidebar/LeftSidebar";
import AddBeneficiaryPage from "./components/Pages/Beneficiary/AddBeneficiaryPage";
import BankTransferPage from "./components/Pages/FundTransfer/BankTransferPage";
import WalletTransferPage from "./components/Pages/FundTransfer/WalletTransferPage";
import ReactIdleTimer from "./components/ReactIdleTimer";
import NotFoundPage from "./components/Pages/NotFoundPage";
import AboutPage from "./components/Pages/AboutPage";
import ChangePassword from "./components/Pages/ChangePasswordPage";
import ContactUsPage from "./components/Pages/ContactUsPage";
import ApplyLoanPage from "./components/Pages/Loan/ApplyLoanPage";
import AppliedLoanPage from "./components/Pages/Loan/AppliedLoanPage";


import routes from "./routes";
import "react-toastify/dist/ReactToastify.min.css";

import {
  far,
  faSquare,
  faLifeRing,
  faCheckCircle,
  faTimesCircle,
  faDotCircle,
  faThumbsUp,
  faComments,
  faFolderOpen,
  faTrashAlt,
  faFileImage,
  faFileArchive,
  faCommentDots,
  faFolder,
  faKeyboard,
  faCalendarAlt,
  faEnvelope,
  faAddressCard,
  faMap,
  faObjectGroup,
  faImages,
  faUser,
  faLightbulb,
  faGem,
  faClock,
  faUserCircle,
  faQuestionCircle,
  faBuilding,
  faBell,
  faFileExcel,
  faFileAudio,
  faFileVideo,
  faFileWord,
  faFilePdf,
  faFileCode,
  faFileAlt,
  faEye,
  faChartBar
} from "@fortawesome/free-regular-svg-icons";
import {
  fas,
  faAngleDoubleRight,
  faAngleDoubleLeft,
  faSmile,
  faHeart,
  faBatteryEmpty,
  faBatteryFull,
  faChevronRight,
  faSitemap,
  faPrint,
  faMapMarkedAlt,
  faTachometerAlt,
  faAlignCenter,
  faExternalLinkAlt,
  faShareSquare,
  faInfoCircle,
  faSync,
  faQuoteRight,
  faStarHalfAlt,
  faShapes,
  faCarBattery,
  faTable,
  faCubes,
  faPager,
  faCameraRetro,
  faBomb,
  faNetworkWired,
  faBusAlt,
  faBirthdayCake,
  faEyeDropper,
  faUnlockAlt,
  faDownload,
  faAward,
  faPlayCircle,
  faReply,
  faUpload,
  faBars,
  faEllipsisV,
  faSave,
  faSlidersH,
  faCaretRight,
  faChevronUp,
  faPlus,
  faLemon,
  faChevronLeft,
  faTimes,
  faChevronDown,
  faFilm,
  faSearch,
  faEllipsisH,
  faCog,
  faArrowsAltH,
  faPlusCircle,
  faAngleRight,
  faAngleUp,
  faAngleLeft,
  faAngleDown,
  faArrowUp,
  faArrowDown,
  faArrowRight,
  faArrowLeft,
  faStar,
  faSignOutAlt,
  faLink
} from "@fortawesome/free-solid-svg-icons";

library.add(
  far,
  faSquare,
  faLifeRing,
  faCheckCircle,
  faTimesCircle,
  faDotCircle,
  faThumbsUp,
  faComments,
  faFolderOpen,
  faTrashAlt,
  faFileImage,
  faFileArchive,
  faCommentDots,
  faFolder,
  faKeyboard,
  faCalendarAlt,
  faEnvelope,
  faAddressCard,
  faMap,
  faObjectGroup,
  faImages,
  faUser,
  faLightbulb,
  faGem,
  faClock,
  faUserCircle,
  faQuestionCircle,
  faBuilding,
  faBell,
  faFileExcel,
  faFileAudio,
  faFileVideo,
  faFileWord,
  faFilePdf,
  faFileCode,
  faFileAlt,
  faEye,
  faChartBar
);

library.add(
  fas,
  faAngleDoubleRight,
  faAngleDoubleLeft,
  faSmile,
  faHeart,
  faBatteryEmpty,
  faBatteryFull,
  faChevronRight,
  faSitemap,
  faPrint,
  faMapMarkedAlt,
  faTachometerAlt,
  faAlignCenter,
  faExternalLinkAlt,
  faShareSquare,
  faInfoCircle,
  faSync,
  faQuoteRight,
  faStarHalfAlt,
  faShapes,
  faCarBattery,
  faTable,
  faCubes,
  faPager,
  faCameraRetro,
  faBomb,
  faNetworkWired,
  faBusAlt,
  faBirthdayCake,
  faEyeDropper,
  faUnlockAlt,
  faDownload,
  faAward,
  faPlayCircle,
  faReply,
  faUpload,
  faBars,
  faEllipsisV,
  faSave,
  faSlidersH,
  faCaretRight,
  faChevronUp,
  faPlus,
  faLemon,
  faChevronLeft,
  faTimes,
  faChevronDown,
  faFilm,
  faSearch,
  faEllipsisH,
  faCog,
  faArrowsAltH,
  faPlusCircle,
  faAngleRight,
  faAngleUp,
  faAngleLeft,
  faAngleDown,
  faArrowUp,
  faArrowDown,
  faArrowRight,
  faArrowLeft,
  faStar,
  faSignOutAlt,
  faLink
);
toast.configure({
  position: "top-center",
  limit: 3
});
toast.clearWaitingQueue();
const App: React.FC = () => {
  return (
    <BrowserRouter>
      <Switch>
        <Route exact path="/api*" component={NotFoundPage} />
        <Route
          exact
          path={routes.app.authentication.login}
          component={LoginPage}
        />
        <Route
          exact
          path={routes.app.authentication.signup}
          component={SignUpPage}
        />
        <Route
          exact
          path={routes.app.authentication.forgot}
          component={ForgotPasswordPage}
        />
        {localStorage.length !== 0 &&
        localStorage.getItem("userData") &&
        JSON.stringify(routes).includes(window.location.pathname) ? (
          <LeftSidebar>
            <ReactIdleTimer />
            <Route exact path={routes.app.about} component={AboutPage} />
            <Route
              exact
              path={routes.app.accountStatement}
              component={AccountStatementPage}
            />
            <Route
              exact
              path={routes.app.dashboard}
              component={DashboardPage}
            />
            <Route
              exact
              path={routes.app.user.userProfile}
              component={UserProfilePage}
            />
            <Route
              exact
              path={routes.app.beneficiary.viewBeneficiary}
              component={ViewBeneficiaryPage}
            />
            <Route
              exact
              path={routes.app.beneficiary.addBeneficiary}
              component={AddBeneficiaryPage}
            />
            <Route
              exact
              path={routes.app.fundTransfer.bank}
              component={BankTransferPage}
            />
            <Route
              exact
              path={routes.app.fundTransfer.wallet}
              component={WalletTransferPage}
            />
            <Route
              exact
              path={routes.app.user.editUser}
              component={EditUserPage}
            />
            <Route
              exact
              path={routes.app.changePassword}
              component={ChangePassword}
            />
             <Route
              exact
              path={routes.app.contactUs}
              component={ContactUsPage}
            />
            <Route
              exact
              path={routes.app.loan.apply}
              component={ApplyLoanPage}
            />
            <Route
              exact
              path={routes.app.loan.appliedLoans}
              component={AppliedLoanPage}
            />
          </LeftSidebar>
        ) : null}

        <Route component={NotFoundPage} />
      </Switch>
    </BrowserRouter>
  );
};

export default App;
