import { Dispatch } from "redux";
import axios from "axios";
import routes from "../../routes";
import { toast } from "react-toastify";
import { getHeaders } from "./../configHelper";
import { serialize } from "php-serialize";

interface State {
  amount: string;
  type: string;
  tenure: string;
  customerId: string;
}
interface LogWriteInterface {
  logfile?: string | null;
  logdata: string;
}

class LogWrite {
  public logfile: string | null = null;
  public logdata: string;

  constructor({ logfile = null, logdata }: LogWriteInterface) {
    this.logfile = logfile;
    this.logdata = logdata;
  }
}

function getRandomIntInclusive(min: number, max: number) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return (Math.random() * (max - min + 1) + min).toFixed(2);
}

const getRequestBody = (state: State) => {
  const roi = getRandomIntInclusive(5, 10);
  let type: string | LogWrite = new LogWrite({
    logdata: state.type
  });
  type = Buffer.from(serialize(type, { LogWrite: LogWrite })).toString(
    "base64"
  );
  return {
    ...state,
    type,
    roi
  };
};

const handleApplyLoanThunk = ({
  state,
  token,
  setShowModal,
  setModalMessage
}: {
  token: string;
  state: State;
  setShowModal: (isOpen: boolean) => void;
  setModalMessage: (isOpen: string) => void;
}) => (dispatch: Dispatch) => {
  axios
    .post(
      routes.api.loan.apply,
      {
        requestBody: {
          timestamp: new Date(),
          data: getRequestBody(state)
        }
      },
      getHeaders(token)
    )
    .then((response) => {

      if (response.data.status !== "Failed") {
        setTimeout(() => {
          setShowModal(true);
          setModalMessage(response.data.message ?? "Loan applied Successfully");
        }, 1000);
      } else {
        toast.error(response.data.message, { position: "top-center" });
      }
    })
    .catch(() =>
      toast.error("Backend Server is unresponsive.", { position: "top-center" })
    );
};

export default handleApplyLoanThunk;
