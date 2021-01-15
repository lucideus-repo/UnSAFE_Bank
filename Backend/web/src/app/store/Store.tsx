import { applyMiddleware, compose, createStore, Store } from "redux";
import thunk from "redux-thunk";
import { combineReducers } from "@reduxjs/toolkit";
import { ReduxState } from "./ReduxState";
import loginSlice from "../slices/LoginSlice";
import dashboardSlice from "../slices/DashboardSlice";
import SignUpSlice from "../slices/SignUpSlice";
import accountStatementSlice from "../slices/AccountStatementSlice";
import userProfileSlice from "../slices/UserProfileSlice";
import viewBeneficiariesSlice from "../slices/ViewBeneficiarySlice";
import themeSlice from "../slices/ThemeSlice";
import forgotPasswordSlice from "../slices/ForgotPasswordSlice";
import addBeneficiarySlice from "../slices/AddBeneficiarySlice";
import bankTransferSlice from "../slices/BankTransferSlice";
import connectionSlice from "../slices/ConnectionSlice";
import deleteBeneficiarySlice from "../slices/DeleteBeneficiarySlice";

const composeEnhancers =
  (window as any).__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const rootReducer = combineReducers<ReduxState>({
  login: loginSlice.reducer,
  dashboard: dashboardSlice.reducer,
  signUp: SignUpSlice.reducer,
  accountStatements: accountStatementSlice.reducer,
  userProfile: userProfileSlice.reducer,
  beneficiariesAlias: viewBeneficiariesSlice.reducer,
  theme: themeSlice.reducer,
  forgotPassword: forgotPasswordSlice.reducer,
  addBeneficiary: addBeneficiarySlice.reducer,
  bankTransfer: bankTransferSlice.reducer,
  connection: connectionSlice.reducer,
  deleteBeneficiary: deleteBeneficiarySlice.reducer
});

export default function configureStore(): Store<ReduxState, any> {
  return createStore(
    rootReducer,
    undefined,
    composeEnhancers(applyMiddleware(thunk))
  );
}
