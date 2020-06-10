import { createSlice } from "@reduxjs/toolkit";
import { DashboardState } from "../store/ReduxState";

const INITIAL_STATE = {
  userData: null
} as DashboardState;

const dashboardSlice = createSlice({
  name: "dashboardSlice",
  initialState: INITIAL_STATE,
  reducers: {
    setUserData: (state: DashboardState, action) => {
      state.userData = action.payload;
    }
  }
});

export default dashboardSlice;
