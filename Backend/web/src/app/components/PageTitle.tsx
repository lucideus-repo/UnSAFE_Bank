import React, { Fragment } from "react";
import { RouteComponentProps, withRouter } from "react-router-dom";

interface Props extends RouteComponentProps<any> {
  titleHeading: string;
  titleDescription: string;
}

let PageTitle = ({ titleHeading, titleDescription }: Props) => {
  return (
    <Fragment>
      <div className="app-page-title">
        <div>
          <div className="app-page-title--first">
            <div className="app-page-title--heading">
              <h1>{titleHeading}</h1>
              <div className="app-page-title--description">
                {titleDescription}
              </div>
            </div>
          </div>
        </div>
      </div>
    </Fragment>
  );
};

export default withRouter(PageTitle);
