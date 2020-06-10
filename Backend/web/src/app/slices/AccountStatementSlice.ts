import { createSlice } from '@reduxjs/toolkit';
import { AccountStatementState } from '../store/ReduxState';

const INITIAL_STATE = {
	loading: false,
	aStatement: [],
	count: -1
} as AccountStatementState;

const accountStatementSlice = createSlice({
	name: 'accountStatementSlice',
	initialState: INITIAL_STATE,
	reducers: {
		setLoading: (state: AccountStatementState) => {
			state.loading = true;
		},
		setLoaded: (state: AccountStatementState) => {
			state.loading = false;
		},
		setAccountStatement: (state: AccountStatementState, action) => {
			state.aStatement = action.payload;
			state.count = action.payload.length;
		},
		resetState: (state: AccountStatementState) => {
			state.loading = false;
			state.aStatement = [];
			state.count = -1;
		}
	}
});

export default accountStatementSlice;
