import { createSlice } from "@reduxjs/toolkit";
import { LoginState } from "../store/ReduxState";

const INITIAL_STATE = {
  currentView: "login",
  email: null,
  isDetailCorrect: true
} as LoginState;

const loginSlice = createSlice({
  name: "loginSlice",
  initialState: INITIAL_STATE,
  reducers: {
    setCorrectDetail: (state: LoginState) => {
      state.isDetailCorrect = true;
    },
    setWrongDetail: (state: LoginState) => {
      state.isDetailCorrect = false;
    },
    setCurrentView: (state: LoginState, action) => {
      state.currentView = action.payload;
    },
    resetState: (state: LoginState) => {
      state.currentView = "login";
      state.email = null;
    },
    setState: (state: LoginState) => {
      state.currentView = "signout";
    }
  }
});

export default loginSlice;
