import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './app/App';
import * as serviceWorker from './serviceWorker';
import {Provider} from "react-redux";
import {Store} from "redux";
import {ReduxState} from "./app/store/ReduxState";
import configureStore from "./app/store/Store";

interface IProps {
    store: Store<ReduxState>;
}

const Root: React.FC<IProps> = (props) => {
    return (
        <Provider store={props.store}>
            <App/>
        </Provider>
    );
};

const store = configureStore();

function render() {
    ReactDOM.render(<Root store={store}/>, document.getElementById('root'));
}

store.subscribe(render);

render();

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
