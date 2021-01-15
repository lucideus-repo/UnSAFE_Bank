import React, { lazy, Suspense, useRef } from 'react';
import { Switch, Route, Redirect, useLocation, withRouter } from 'react-router-dom';
import LeftSidebar from "./components/Sidebar/LeftSidebar";
import AddBeneficiaryPage from "./components/Pages/Beneficiary/AddBeneficiaryPage";
import BankTransferPage from "./components/Pages/FundTransfer/BankTransferPage";
import WalletTransferPage from "./components/Pages/FundTransfer/WalletTransferPage";
import ReactIdleTimer from "./components/ReactIdleTimer";
import NotFoundPage from "./components/Pages/NotFoundPage";
import routes from "./routes";
import LoginPage from "./components/Pages/Authentication/LoginPage";
import DashboardPage from "./components/Pages/DashboardPage";
import SignUpPage from "./components/Pages/Authentication/SignUpPage";
import AccountStatementPage from "./components/Pages/AccountStatementPage";
import UserProfilePage from "./components/Pages/UserProfilePage";
import ViewBeneficiaryPage from "./components/Pages/Beneficiary/ViewBeneficiaryPage";
import ForgotPasswordPage from "./components/Pages/Authentication/ForgotPasswordPage";

const Routes = () => {
  const location = useLocation();

  
  return (
    <Switch>
      <Route>
        <Switch>
        <Route  path={routes.app.authentication.login} component={LoginPage} />
        <Route  path={routes.app.authentication.signup} component={SignUpPage} />
        <Route  path={routes.app.authentication.forgot} component={ForgotPasswordPage} />
        <Route component={NotFoundPage} />
   
       
          <LeftSidebar>
            <ReactIdleTimer />
            <Route  path={routes.app.accountStatement} component={AccountStatementPage} />
            <Route  path={routes.app.dashboard} component={DashboardPage} />
            <Route  path={routes.app.user.userProfile} component={UserProfilePage} />
            <Route  path={routes.app.beneficiary.viewBeneficiary} component={ViewBeneficiaryPage} />
            <Route  path={routes.app.beneficiary.addBeneficiary} component={AddBeneficiaryPage} />
            <Route  path={routes.app.fundTransfer.bank} component={BankTransferPage} />
            <Route  path={routes.app.fundTransfer.wallet} component={WalletTransferPage} />
          </LeftSidebar>
          </Switch>
      </Route>
        <Route component={NotFoundPage} />
      </Switch>
  );
};

export default Routes;
