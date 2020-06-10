import React, { Fragment } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Row, Col, CardBody, Card } from 'reactstrap';
import PageTitle from '../PageTitle';
import ReactCountUp from 'react-countup';

const HomePage = () => {
	let userData = JSON.parse(localStorage.getItem('userData')!);
	if (localStorage.length === 0  || !userData) {
		document.location.href = '/';
	}
	let getCurrencySymbol = (payload: string) => {
		let currency_symbols: any = {
			USD: '$ ',
			EUR: '€ ',
			CRC: '₡ ',
			GBP: '£ ',
			ILS: '₪ ',
			INR: '₹  ',
			JPY: '¥ ',
			KRW: '₩ ',
			NGN: '₦ ',
			PHP: '₱ ',
			PLN: 'zł ',
			PYG: '₲ ',
			THB: '฿ ',
			UAH: '₴ ',
			VND: '₫ '
		};
		if (currency_symbols[payload] !== undefined) {
			return currency_symbols[payload];
		}
		return '';
	};

	return (
		<div>
			<Fragment>
				<PageTitle titleHeading={'Hello, ' + userData.fname} titleDescription="This is your Dashboard" />
			</Fragment>

			<Row className="d-flex justify-content-center" xl="3" xs="1" sm="2" md="3" lg="3">
				<Col>
					<Card className="card-box bg-second border-0 text-light mb-5">
						<CardBody>
							<div className="d-flex align-items-start">
								<div className="font-weight-bold">
									<small className="text-white-50 d-block mb-1 text-uppercase">Account Balance</small>
									<span className="font-size-xxl mt-1">
										<ReactCountUp
											start={0}
											end={parseFloat(userData.acctBalance)}
											duration={2}
											useEasing={true}
											separator=","
											decimals={2}
											decimal="."
											prefix={getCurrencySymbol(userData.currency)}
											suffix=""
										/>
									</span>
								</div>
								<div className="ml-auto">
									<div className="bg-white text-center text-success d-40 rounded-circle p-1">
										<FontAwesomeIcon icon={[ 'far', 'chart-bar' ]} className="font-size-xl" />
									</div>
								</div>
							</div>
							<div className="mt-2">
								<span className="text-success">Customer ID: </span>
								<span className="text-white-50">{userData.userid}</span>
							</div>
						</CardBody>
					</Card>
				</Col>
			</Row>
		</div>
	);
};

export default HomePage;
