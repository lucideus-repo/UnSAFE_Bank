import { createSlice } from "@reduxjs/toolkit";
import { UserProfileState } from "../store/ReduxState";

const INITIAL_STATE = {
  loading: false,
  userProfile: {},
  count: -1
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
      state.count = action.payload.fname.length;
    },
    setLoadingFailed: (state: UserProfileState) => {
      state.loading = false;
      state.count = -1;
    }
  }
});

export default userprofileSlice;
