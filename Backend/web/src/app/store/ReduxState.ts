export interface LoginState {
  currentView: null | "login" | "signout";
  email: string | null;
  isDetailCorrect: boolean;
}

export interface DashboardState {
  userData: any | null;
}

export interface SignUpState {
  error: string | null;
  userId: string;
  refNo: string | null;
}

export interface AccountStatement {
  tdate: string;
  fromtoAcc: string;
  remarks: string;
  amount: string;
  referenceNo: string;
  type: string;
}

export interface AccountStatementState {
  loading: boolean;
  count: number;
  aStatement: AccountStatement[];
}

export interface UserProfileState {
  loading: boolean;
  userProfile: any;
}

export interface ViewBeneficiariesState {
  loading: boolean;
  count: number;
  beneficiariesAlias: string[];
  alias: string;
  accountNumber: string;
  ifscCode: string;
  creationDateTime: string;
  isSuccess:boolean;
  errorMessage:string;
}

export interface ThemeState {
  sidebarToggleMobile: boolean;
}
export interface ConnectionState {
  ipAddress: string;
  port: string;
}

export interface ForgotPasswordState {
  OTPDecoded: string;
  OTPResponse: string;
}

export interface AddBeneficiaryState {
  OTPDecoded: string;
  OTPResponse: string;
}

export interface DeleteBeneficiaryState {
  OTPDecoded: string;
  OTPResponse: string;
  isSuccessful:boolean;
}
export interface BankTransferState {
  loading: boolean;
  count: number;
  beneficiaryAlias: any[];
  OTPDecoded: string;
  OTPResponse: string;
  referenceNumber: string;
  showModal: boolean;
}

export interface ReduxState {
  login: LoginState;
  dashboard: DashboardState;
  signUp: SignUpState;
  accountStatements: AccountStatementState;
  userProfile: UserProfileState;
  beneficiariesAlias: ViewBeneficiariesState;
  theme: ThemeState;
  forgotPassword: ForgotPasswordState;
  addBeneficiary: AddBeneficiaryState;
  bankTransfer: BankTransferState;
  connection: ConnectionState;
  deleteBeneficiary:DeleteBeneficiaryState;
}
