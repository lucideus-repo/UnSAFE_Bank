import { createSlice } from "@reduxjs/toolkit";
import { ThemeState } from "../store/ReduxState";

const INITIAL_STATE = {
  sidebarToggleMobile: false
} as ThemeState;

const themeSlice = createSlice({
  name: "themeSlice",
  initialState: INITIAL_STATE,
  reducers: {
    setSidebarToggleMobile: (state: ThemeState, action) => {
      state.sidebarToggleMobile = action.payload;
    }
  }
});

export default themeSlice;
