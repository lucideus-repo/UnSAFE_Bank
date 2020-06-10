import { createSlice } from "@reduxjs/toolkit";
import { ForgotPasswordState } from "../store/ReduxState";


const INITIAL_STATE = {
  OTPDecoded: "",
  OTPResponse: ""
} as ForgotPasswordState;

const forgotpasswordSlice = createSlice({
  name: "forgotpasswordSlice",
  initialState: INITIAL_STATE,
  reducers: {
    setOTPDecoded: (state: ForgotPasswordState, action) => {
      state.OTPDecoded = action.payload;
    },
    setOTPResponse: (state: ForgotPasswordState, action) => {
      state.OTPResponse = action.payload;
    },
    setResetOTP: (state: ForgotPasswordState) => {
      state.OTPResponse = "";
      state.OTPDecoded = "";
    }
  }
});

export default forgotpasswordSlice;
