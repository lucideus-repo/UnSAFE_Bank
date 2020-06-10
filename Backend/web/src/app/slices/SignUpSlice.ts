import { createSlice } from "@reduxjs/toolkit";
import { SignUpState } from "../store/ReduxState";

const INITIAL_STATE = {
  error: "",
  userId: "",
  refNo: ""
} as SignUpState;

const SignUpSlice = createSlice({
  name: "signUpSlice",
  initialState: INITIAL_STATE,
  reducers: {
    setError: (state: SignUpState, action) => {
      state.error = action.payload;
    },
    setState: (state: SignUpState, action) => {
      state.userId = action.payload.userId;
      state.refNo = action.payload.refNo;
      state.error = "";
    },
    setReset: (state: SignUpState) => {
      state.userId = "";
      state.refNo = "";
      state.error = "";
    }
  }
});

export default SignUpSlice;
