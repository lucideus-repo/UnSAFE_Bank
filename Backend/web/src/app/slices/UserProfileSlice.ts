import { createSlice } from "@reduxjs/toolkit";
import { UserProfileState } from "../store/ReduxState";

const INITIAL_STATE = {
  loading: false,
  userProfile: null,
} as UserProfileState;

const userprofileSlice = createSlice({
  name: "profileSlice",
  initialState: INITIAL_STATE,
  reducers: {
    setLoading: (state: UserProfileState) => {
      state.loading = true;
    },
    setLoaded: (state: UserProfileState) => {
      state.loading = false;
    },
    setUserInfomation: (state: UserProfileState, action) => {
      state.userProfile = action.payload;
    },
    setLoadingFailed: (state: UserProfileState) => {
      state.loading = false;
      state.userProfile = null;
    }
  }
});

export default userprofileSlice;
