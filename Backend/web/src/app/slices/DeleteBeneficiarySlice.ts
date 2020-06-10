import { createSlice } from "@reduxjs/toolkit";
import { DeleteBeneficiaryState } from "../store/ReduxState";

const INITIAL_STATE = {
  OTPDecoded: "",
  OTPResponse: "",
  isSuccessful: false
} as DeleteBeneficiaryState;

const deleteBeneficiarySlice = createSlice({
  name: "deleteBeneficiarySlice",
  initialState: INITIAL_STATE,
  reducers: {
    setOTPDecoded: (state: DeleteBeneficiaryState, action) => {
      state.OTPDecoded = action.payload;
    },
    setOTPResponse: (state: DeleteBeneficiaryState, action) => {
      state.OTPResponse = action.payload;
    },
    setisSuccessful: (state: DeleteBeneficiaryState, action) => {
      state.isSuccessful = action.payload;
    },
    setResetOTP: (state: DeleteBeneficiaryState) => {
      state.OTPResponse = "";
      state.OTPDecoded = "";
      state.isSuccessful = false;
    }
  }
});

export default deleteBeneficiarySlice;
