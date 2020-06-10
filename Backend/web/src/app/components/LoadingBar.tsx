import React, { Fragment } from "react";

import { ScaleLoader } from "react-spinners";
export default function LoadingBar() {
  return (
    <Fragment>
      <div className="d-flex flex-row text-center flex-wrap justify-content-center">
        <div className="rounded-sm card-box shadow-none p-5 m-5">
          <div
            className="d-flex align-items-center justify-content-center"
            style={{ width: "150px", height: "80px" }}
          >
            <ScaleLoader color={"var(--vicious-stance)"} loading={true} />
          </div>
        </div>
      </div>
    </Fragment>
  );
}
