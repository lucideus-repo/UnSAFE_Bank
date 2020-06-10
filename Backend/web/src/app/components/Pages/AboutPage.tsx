import React, { useState, useEffect, Fragment } from "react";
import LoadingBar from "../LoadingBar";
import axios from "axios";
import routes from "../../routes";
import { toast } from "react-toastify";

const AboutPage = () => {
  const [data, setdata] = useState("");
  useEffect(() => {
    axios
      .get(routes.api.about)
      .then(response => {
        if (response.data.status !== "Failed") {
          setdata(response.data);
        } else {
          toast.error("Nice try!", { position: "top-center" });
        }
      })
      .catch(res => toast.error("Backend Server is unresponsive.", { position: "top-center" }));
  }, []);
  const createMarkup = () => {
    return {
      __html: data!
    };
  };
  if (!data) {
    return (
      <div>
        <LoadingBar />
      </div>
    );
  } else {
    return (
      <Fragment>
        <div dangerouslySetInnerHTML={createMarkup()} />
      </Fragment>
    );
  }
};

export default AboutPage;
