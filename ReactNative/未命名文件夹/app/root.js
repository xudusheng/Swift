/**
 * Created by zhengda on 16/10/18.
 */

import React, {Component} from 'react';

import {Provider} from 'react-redux';

import APP from './app';

import configureStore from './stores/config-store';

const store = configureStore();

export default class Root extends Component {

    render() {
        return (
            <Provider store={store}>
                <APP/>
            </Provider>
        );
    };
};

module.exports = Root;

