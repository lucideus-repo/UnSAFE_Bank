import { Dispatch } from 'redux';
import axios from 'axios';
import routes from '../../routes';
import bankTransferSlice from '../../slices/BankTransferSlice';
import { toast } from 'react-toastify';
import { getHeaders } from '../configHelper';

const handleBeneficiaryForFundTransfer = ({ token }: { token: string }) => (dispatch: Dispatch) => {
	dispatch(bankTransferSlice.actions.setLoading);
	axios
		.post(routes.api.fundTransfer.getAliasBankTransfer, {
			requestBody: {
				timestamp: '325553',
				// token: token,
				device: {
					deviceid: 'UHDGGF735SVHFVSX',
					os: 'ios',
					host: 'lucideustech.com'
				},
				data: {}
			}
		},getHeaders(token))
		.then((response) => {
			if (response.data.status !== 'Failed') {
				dispatch(bankTransferSlice.actions.setLoaded());
				dispatch(bankTransferSlice.actions.setAlias(response.data.data.result));
			}
		}).catch(res=>(toast.error("Backend Server is unresponsive.",{position: "top-center"})));
};

export default handleBeneficiaryForFundTransfer;
