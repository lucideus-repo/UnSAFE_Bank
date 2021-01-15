import React, { useEffect, useState } from "react";

import { Card, Col, Table } from "reactstrap";

import LoadingBar from "../../LoadingBar";

import axios from "axios";
import routes from "../../../routes";
import { toast } from "react-toastify";
import { getHeaders } from "../../../thunks/configHelper";

const AccountStatementPage = () => {
  let userData = JSON.parse(localStorage.getItem("userData")!);
  if (localStorage.length === 0 || !userData) {
    document.location.href = "/";
  }

  const [data, setdata] = useState<string | any[]>("");

  useEffect(() => {
    axios
      .post(
        routes.api.loan.appliedLoan,
        {
          requestBody: {
            timestamp: new Date(),
            data: ""
          }
        },
        getHeaders(userData.token)
      )
      .then((response) => {
        if (response.data.status !== "Failed") {
          setdata(response.data.data);
        } else {
          toast.error(response.data.message, {
            position: "top-center"
          });
        }
      })
      .catch((res) =>
        toast.error("Backend Server is unresponsive.", {
          position: "top-center"
        })
      );
  }, [userData.token]);
  if (!data) {
    return (
      <div>
        <LoadingBar />
      </div>
    );
  } else {
    let getDate = (date: string) => {
      let newDate: any = date.split("-");
      return newDate.reverse().join("-");
    };

    const printAccountStatement = () => {
      if (Array.isArray(data) && data.length > 0)
        return (
          <tbody>
            {data.map((d) => (
              <tr key={d.referenceNo}>
                <td className="text-center">{getDate(d.AppliedDate)}</td>
                <td className="text-center">{d.amount}</td>
                <td className="text-center">{d.roi}</td>
                <td className="text-center"> {d.type}</td>
                <td className="text-center"> {d.tenure}</td>
              </tr>
            ))}
          </tbody>
        );
    };
    let getCurrencySymbol = (payload: string) => {
      let currency_symbols: any = {
        USD: "$",
        EUR: "€",
        CRC: "₡",
        GBP: "£",
        ILS: "₪",
        INR: "₹",
        JPY: "¥",
        KRW: "₩",
        NGN: "₦",
        PHP: "₱",
        PLN: "zł",
        PYG: "₲",
        THB: "฿ ",
        UAH: "₴",
        VND: "₫"
      };
      if (currency_symbols[payload] !== undefined) {
        return currency_symbols[payload];
      }
      return "";
    };

    return (
      <div>
        <Col className="text-center container vertical-center">
          <Card className="card-box mb-5 ml-4 mr-4 pb-1">
            <div className="font-size-lg px-3 py-4 font-weight-bold">
              Applied Loans
            </div>
            <div className="table-responsive-md ">
              <Table borderless className="text-nowrap mb-0">
                <thead>
                  <tr>
                    <th className="text-uppercase bg-secondary">Date</th>
                    <th className="text-uppercase bg-secondary text-center">
                      {"amount(" + getCurrencySymbol(userData.currency) + ")"}
                    </th>
                    <th className="text-uppercase bg-secondary text-center">
                      Rate of Interest
                    </th>
                    <th className="text-uppercase bg-secondary text-center">
                      type
                    </th>
                    <th className="text-uppercase bg-secondary text-center">
                      Tenure (Months)
                    </th>
                  </tr>
                </thead>
                {printAccountStatement()}
              </Table>
              {!data.length ? (
                <p className="font-size-md mt-3">No Record Found</p>
              ) : (
                <div />
              )}
            </div>
          </Card>
        </Col>
      </div>
    );
  }
};

export default AccountStatementPage;
