import { Dispatch } from 'redux';
import axios from 'axios';
import routes from '../../routes';
import viewBeneficiariesSlice from '../../slices/ViewBeneficiarySlice';
import { toast } from 'react-toastify';
import { getHeaders } from '../configHelper';

const handleViewBeneficiaries = ({ token }: { token: string }) => (dispatch: Dispatch) => {
	dispatch(viewBeneficiariesSlice.actions.setLoading);
	axios
		.post(routes.api.beneficiary.allBeneficiary, {
			requestBody: {
				timestamp: '325553',
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
				dispatch(viewBeneficiariesSlice.actions.setLoaded());
				dispatch(viewBeneficiariesSlice.actions.setAlias(response.data.data.alias));
			}
		}).catch(res=>(toast.error("Backend Server is unresponsive.",{position: "top-center"})));
};

export default handleViewBeneficiaries;
