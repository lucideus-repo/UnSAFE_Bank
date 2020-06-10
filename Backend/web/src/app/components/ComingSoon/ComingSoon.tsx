import React, { Fragment } from 'react';
import { Card, Badge } from 'reactstrap';
import svgImage6 from '../../assets/images/illustrations/data_points.svg';

export default function ComingSoon() {
	return (
		<Fragment>
			<div className="container">
				<Card className="shadow-xl mb-5">
					<div className="p-3 p-xl-2">
						<div className="d-flex flex-column flex-xl-row flex-lg-row align-items-center">
							<div className="pl-0 pl-xl-4 py-0 py-md-2 text-center text-xl-left">
								<div className="mb-4">
									<Badge pill color="warning">
										Latest release
									</Badge>
									<h1 className="display-3 my-3 font-weight-bold">Coming Soon </h1>
									<p className="font-size-lg text-black-50">
										Our team is working hard to provide you a seamless experience.
									</p>
								</div>
							</div>
							<div className="p-4">
								<img src={svgImage6} className="img-fluid" alt="..." />
							</div>
						</div>
					</div>
				</Card>
			</div>
		</Fragment>
	);
}
