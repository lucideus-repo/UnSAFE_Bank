import { createSlice } from "@reduxjs/toolkit";
import { AddBeneficiaryState } from "../store/ReduxState";

const INITIAL_STATE = {
  OTPDecoded: "",
  OTPResponse: ""
} as AddBeneficiaryState;

const addBeneficiarySlice = createSlice({
  name: "addBeneficiarySlice",
  initialState: INITIAL_STATE,
  reducers: {
    setOTPDecoded: (state: AddBeneficiaryState, action) => {
      state.OTPDecoded = action.payload;
    },
    setOTPResponse: (state: AddBeneficiaryState, action) => {
      state.OTPResponse = action.payload;
    },
    setResetOTP: (state: AddBeneficiaryState) => {
      state.OTPResponse = "";
      state.OTPDecoded = "";
    }
  }
});

export default addBeneficiarySlice;
