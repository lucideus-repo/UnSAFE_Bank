import React, { Fragment } from "react";
import PageNotFound from "../../assets/images/illustrations/404.svg";
import { Col, Button } from "reactstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
class NotFoundPage extends React.Component {
  render() {
    return (
      <div>
        <Fragment>
          <div className="app-wrapper bg-light">
            <div className="app-main">
              <div className="app-content p-0">
                <div className="app-inner-content-layout--main">
                  <div className="flex-grow-1 w-100 d-flex align-items-center">
                    <div className="bg-composed-wrapper--content">
                      <div className="hero-wrapper bg-composed-wrapper min-vh-100">
                        <div className="flex-grow-1 w-100 d-flex align-items-center">
                          <Col
                            lg="6"
                            md="9"
                            className="px-4 mx-auto text-center text-black"
                          >
                            <img
                              src={PageNotFound}
                              className="w-50 mx-auto d-block my-5 img-fluid"
                              alt="..."
                            />

                            <h1 className="display-1 mb-3 px-4 font-weight-bold">
                              404 Page not Found
                            </h1>
                            <h3 className="font-size-xxl line-height-sm font-weight-light d-block px-3 mb-3 text-black-50">
                              The page you were looking for doesn't exist.
                            </h3>
                            <p>
                              You may have mistyped the address or the page may
                              have moved.
                            </p>
                            <Button
                              onClick={e => window.history.back()}
                              color="second"
                              size="lg"
                              className="px-5 mt-4 mb-3"
                            >
                              <span className="btn-wrapper--icon">
                                <FontAwesomeIcon icon={["fas", "arrow-left"]} />
                              </span>
                              <span className="btn-wrapper--label">Back</span>
                            </Button>
                          </Col>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </Fragment>
      </div>
    );
  }
}
export default NotFoundPage;
