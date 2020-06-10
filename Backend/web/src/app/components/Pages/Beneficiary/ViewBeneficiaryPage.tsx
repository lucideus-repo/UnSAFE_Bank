import React, { Fragment, useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Row, Col, CardBody } from 'reactstrap';
import BeneficiaryDetailModal from '../../BeneficiaryDetailModal';
import { RouteComponentProps } from 'react-router-dom';
import { ViewBeneficiariesState } from '../../../store/ReduxState';
import handleViewBeneficiaries from '../../../thunks/Beneficiary/handleViewBeneficiaryThunk';
import handleBeneficiaryDetails from '../../../thunks/Beneficiary/handleBeneficiaryDetailsThunk';
import { bindActionCreators, Dispatch } from 'redux';
import { connect } from 'react-redux';
import LoadingBar from '../../LoadingBar';
import viewBeneficiariesSlice from '../../../slices/ViewBeneficiarySlice';

interface Props extends RouteComponentProps<any> {
	beneficiariesAlias: ViewBeneficiariesState;
	handleBeneficiariesAlias: (args: { token: string }) => void;
	handleBeneficiaryDetails: (args: { token: string; alias: string }) => void;
	handleResetBeneficiaryDetails: () => void;
}

const ViewBeneficiariesPage = ({
	beneficiariesAlias,
	handleBeneficiariesAlias,
	handleBeneficiaryDetails,
	handleResetBeneficiaryDetails,
	history
}: Props) => {
	let userData = JSON.parse(localStorage.getItem('userData')!);
	if (localStorage.length === 0  || !userData) {
		document.location.href = '/';
	}

	let getDate = (date: string) => {
		let newDate: any = date.split(' ')[0];
		newDate = newDate.split('-');
		return newDate.reverse().join('-');
	};
	const [ modal4, setModal4 ] = useState(false);

	const onCloseModal = () => {
		onClickBeneficiariesAlias(userData.token);
		handleResetBeneficiaryDetails();
		setModal4(!modal4);
	};

	let getBeneficiaryDetails = (token: string, alias: string) => {
		handleBeneficiaryDetails({
			token: token,
			alias: alias
		});

		onCloseModal();
	};

	let onClickBeneficiariesAlias = (payload: string) => {
		handleBeneficiariesAlias({
			token: payload
		});
	};

	if (beneficiariesAlias.loading === false && beneficiariesAlias.count === -1) {
		onClickBeneficiariesAlias(userData.token);
		return (
			<div>
				<LoadingBar />
			</div>
		);
	} else if (beneficiariesAlias.count > 0) {
		return (
			<Fragment>
				<div className="pt-5 px-5 mb-5 rounded">
					<Row xl="4" lg="4" md="4" sm="3" xs="2">
						{beneficiariesAlias.beneficiariesAlias.map((beneficiary) => (
							<Col key={beneficiary}>
								<a
									href="#"
									onClick={(e) => getBeneficiaryDetails(userData.token, beneficiary)}
									className="mb-5 card card-box card-box-border-bottom card-box-hover-rise-alt"
								>
									<CardBody>
										<div className="align-box-row">
											<div className="text-left">
												<div className="mt-1">
													<FontAwesomeIcon
														icon={[ 'far', 'user' ]}
														className="font-size-lg text-second"
													/>
												</div>
											</div>
											<div className="text-center ml-auto">
												<b className="font-size-lg text-black pr-1">{beneficiary}</b>
											</div>
											<div className="ml-auto card-hover-indicator" />
										</div>
									</CardBody>
								</a>
							</Col>
						))}
					</Row>
				</div>

				{modal4 ? (
					<BeneficiaryDetailModal
						handleOkayButton={onCloseModal}
						open={modal4}
						alias={beneficiariesAlias.alias}
						IFSC={beneficiariesAlias.ifscCode}
						accountNumber={beneficiariesAlias.accountNumber}
						creationDate={getDate(beneficiariesAlias.creationDateTime)}
						successful={beneficiariesAlias.isSuccess}
						errorMessage={beneficiariesAlias.errorMessage}
					/>
				) : (
					<div />
				)}
			</Fragment>
		);
	} else {
		return (
			<div>
				<h1>NO RECORD FOUND</h1>
			</div>
		);
	}
};

const mapStateToProps = (state: { beneficiariesAlias: ViewBeneficiariesState }) => {
	return {
		beneficiariesAlias: state.beneficiariesAlias
	};
};

const mapDispatchToProps = (dispatch: Dispatch) => {
	return bindActionCreators(
		{
			handleBeneficiariesAlias: handleViewBeneficiaries,
			handleBeneficiaryDetails: handleBeneficiaryDetails,
			handleResetBeneficiaryDetails: viewBeneficiariesSlice.actions.resetBeneficiaryDetails
		},
		dispatch
	);
};

export default connect(mapStateToProps, mapDispatchToProps)(ViewBeneficiariesPage);
