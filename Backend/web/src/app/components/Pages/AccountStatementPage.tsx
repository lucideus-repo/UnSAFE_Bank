import React from "react";
import { connect } from "react-redux";
import { RouteComponentProps } from "react-router";
import { Badge, Card, Col, Table } from "reactstrap";
import { bindActionCreators, Dispatch } from "redux";
import { AccountStatementState } from "../../store/ReduxState";
import handleAccountStatementThunk from "../../thunks/handleAccountStatementThunk";
import LoadingBar from "../LoadingBar";
import accountStatementSlice from "../../slices/AccountStatementSlice";
interface Props extends RouteComponentProps<any> {
  accountStatements: AccountStatementState;
  handleReset: () => void;
  handleAccountStatement: (args: { token: string }) => void;
}

const AccountStatementPage = ({ accountStatements, handleAccountStatement, handleReset, history }: Props) => {
  let userData = JSON.parse(localStorage.getItem("userData")!);
  if (localStorage.length === 0 || !userData) {
    document.location.href = "/";
  }
//@ts-ignore
  history.listen((location, action) => {
    handleReset();
  });

  let onClickAccountStatement = (payload: string) => {
    handleAccountStatement({
      token: payload
    });
  };
  if (accountStatements.loading === false && accountStatements.count === -1) {
    onClickAccountStatement(userData.token);

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
    let renderSwitch = (payload: string) => {
      switch (payload) {
        case "CREDIT":
          return <Badge color="success">CREDIT</Badge>;
        default:
          return <Badge color="danger">DEBIT</Badge>;
      }
    };

    const printAccountStatement = () => {
      if (accountStatements.count > 0)
        return (
          <tbody>
            {accountStatements.aStatement.map(d => (
              <tr key={d.referenceNo}>
                <td className="text-center">{getDate(Object.values(d)[0])}</td>
                <td className="text-center">{Object.values(d)[1]}</td>
                <td className="text-center">{d.remarks}</td>

                <td className="text-center"> {d.amount}</td>
                <td className="text-center"> {d.referenceNo}</td>
                <td className="text-center"> {renderSwitch(d.type)}</td>
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
            <div className="font-size-lg px-3 py-4 font-weight-bold">Account Statement</div>
            <div className="table-responsive-md ">
              <Table borderless className="text-nowrap mb-0">
                <thead>
                  <tr>
                    <th className="text-uppercase bg-secondary">Date</th>
                    <th className="text-uppercase bg-secondary">Account Number</th>
                    <th className="text-uppercase bg-secondary text-center">remarks</th>
                    <th className="text-uppercase bg-secondary text-center">
                      {"amount(" + getCurrencySymbol(userData.currency) + ")"}
                    </th>
                    <th className="text-uppercase bg-secondary text-center">reference Number</th>
                    <th className="text-uppercase bg-secondary text-center">type</th>
                  </tr>
                </thead>
                {printAccountStatement()}
              </Table>
              {!accountStatements.count ? <p className="font-size-md mt-3">No Transaction Found</p> : <div />}
            </div>
          </Card>
        </Col>
      </div>
    );
  }
};

const mapStateToProps = (state: { accountStatements: AccountStatementState }) => {
  return {
    accountStatements: state.accountStatements
  };
};

const mapDispatchToProps = (dispatch: Dispatch) => {
  return bindActionCreators(
    {
      handleAccountStatement: handleAccountStatementThunk,
      handleReset: accountStatementSlice.actions.resetState
    },
    dispatch
  );
};

export default connect(mapStateToProps, mapDispatchToProps)(AccountStatementPage);
