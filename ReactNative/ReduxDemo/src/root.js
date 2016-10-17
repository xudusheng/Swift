/**
 * Created by xudosom on 2016/10/17.
 */

import React, {Component} from 'react';
import {Provider} from 'react-redux';
import App from './containers/app';

import configureStore from './stores/config-store';

const store = configureStore();

export default class Root extends Component {
    render() {
        return (
            <Provider store={store}>
                <App/>
            </Provider>
        );
    };
};