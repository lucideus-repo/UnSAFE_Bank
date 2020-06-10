import { createSlice } from "@reduxjs/toolkit";
import { ConnectionState } from "../store/ReduxState";

const INITIAL_STATE = {
  ipAddress: "localhost",
  port: "80"
} as ConnectionState;

const connectionSlice = createSlice({
  name: "connectionSlice",
  initialState: INITIAL_STATE,
  reducers: {
    setConnection: (state: ConnectionState, action) => {
      state.ipAddress = action.payload.ipAddress;
      state.port = action.payload.port;
    }
  }
});

export default connectionSlice;
