import { Dispatch } from 'redux';
import axios from 'axios';
import routes from '../../routes';
import SignUpSlice from '../../slices/SignUpSlice';
import { toast } from 'react-toastify';

const getErrorMessage = (error: string) => {
	let parameter = error.split(' ');
	if (parameter.length === 4) {
		switch (parameter[0]) {
			case 'mobile':
				return 'Mobile Number already registered with us.';
			case 'email':
				return 'Email address already registered with us.';
			default:
				return parameter.join(' ');
		}
	} else {
		let ReadableParameter: any = {
			fname: 'First Name',
			lname: 'Last Name',
			gndr: 'Gender',
			mobile: 'Mobile Number',
			address: 'Address',
			passwd: 'Password',
			dob: 'Date of Birth',
			email: 'Email Adress'
		};
		const ReadableError = ReadableParameter[parameter[1]] + ' is not a valid input';
		return ReadableError;
	}
};
const handleSignUpThunk = ({ newData }: { newData: any }) => (dispatch: Dispatch) => {
	axios
		.post(routes.api.authentication.signup, {
			requestBody: {
				timestamp: '15442433999',
				device: {
					deviceid: 'UHDGGF735SVHFVSX',
					os: 'iOS',
					host: 'lucideustech.com'
				},
				data: {
					firstname: newData.firstName,
					lastname: newData.lastName,
					gndr: newData.gender,
					mobile: newData.mobile,
					email: newData.email,
					passwd: newData.password,
					countryId: 'IND',
					address: newData.address,
					dob: newData.dob
				}
			}
		})
		.then((response) => {
			if (response.data.status !== 'Failed') {
				dispatch(SignUpSlice.actions.setState(response.data.data));
			} else {
				toast.error(getErrorMessage(response.data.message), {
					position: "top-center" ,

					autoClose: 4000
				});
				toast.clearWaitingQueue();

			}
		}).catch(res=>(toast.error("Backend Server is unresponsive.",{position: "top-center"})));
};

export default handleSignUpThunk;
