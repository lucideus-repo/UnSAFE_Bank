import { createSlice } from '@reduxjs/toolkit';
import { ViewBeneficiariesState } from '../store/ReduxState';

const INITIAL_STATE = {
	loading: false,
	beneficiariesAlias: [],
	count: -1,
	accountNumber: '',
	ifscCode: '',
	alias: '',
	creationDateTime: '',
	isSuccess:true,
	errorMessage:''
} as ViewBeneficiariesState;

const viewBeneficiariesSlice = createSlice({
	name: 'viewBeneficiariesSlice',
	initialState: INITIAL_STATE,
	reducers: {
		setLoading: (state: ViewBeneficiariesState) => {
			state.loading = true;
		},
		setLoaded: (state: ViewBeneficiariesState) => {
			state.loading = false;
		},
		setAlias: (state: ViewBeneficiariesState, action) => {
			state.beneficiariesAlias = action.payload;
			state.count = action.payload.length;
		},

		setBeneficiaryDetails: (state: ViewBeneficiariesState, action) => {
			state.accountNumber = action.payload.accountNumber;
			state.ifscCode = action.payload.ifscCode;
			state.alias = action.payload.alias;
			state.creationDateTime = action.payload.creationDateTime;
		},
		resetBeneficiaryDetails: (state: ViewBeneficiariesState) => {
			state.accountNumber = 'Retrieving';
			state.ifscCode = 'Retrieving';
			state.alias = 'Retrieving';
			state.creationDateTime = '0000-00-00';
			state.isSuccess=true;
			state.errorMessage="";
		},
		setIsSuccess: (state: ViewBeneficiariesState, action) => {
			state.isSuccess=action.payload;
		},
		setErrorMessage: (state: ViewBeneficiariesState, action) => {
			state.errorMessage=action.payload;
		}

	}
});

export default viewBeneficiariesSlice;
