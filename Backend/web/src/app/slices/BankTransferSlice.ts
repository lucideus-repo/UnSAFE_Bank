import { createSlice } from '@reduxjs/toolkit';
import { BankTransferState } from '../store/ReduxState';

const INITIAL_STATE = {
	loading: false,
	beneficiaryAlias: [],
	count: -1,
	OTPDecoded: '',
	OTPResponse: '',
	referenceNumber:"",
	showModal:false
} as BankTransferState;


const bankTransferSlice = createSlice({
	name: 'bankTransferSlice',
	initialState: INITIAL_STATE,
	reducers: {
		setLoading: (state: BankTransferState) => {
			state.loading = true;
		},
		setLoaded: (state: BankTransferState) => {
            state.loading = false;
		},
		setAlias: (state: BankTransferState, action) => {
			state.count=action.payload.length
			state.beneficiaryAlias = action.payload;
		},

		setOTPDecoded: (state: BankTransferState, action) => {
			state.OTPDecoded = action.payload;
		},
		setOTPResponse: (state: BankTransferState, action) => {
			state.OTPResponse = action.payload;
		},
		setResetOTP: (state: BankTransferState) => {
			state.OTPResponse = '';
			state.OTPDecoded = '';
		},
		setModal: (state: BankTransferState) => {
            state.showModal = true;
		},
		setReferenceNumber: (state: BankTransferState,action) => {
            state.referenceNumber = action.payload;
		},
		resetModal: (state: BankTransferState) => {
            state.showModal = false;
		},
		resetReferenceNumber: (state: BankTransferState) => {
            state.referenceNumber = "";
		}


		
	}
});

export default bankTransferSlice;
