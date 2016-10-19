/**
 * Created by zhengda on 16/10/18.
 */

import React, {Component} from 'react';

import {Provider} from 'react-redux';

import Main from './pages/main/main';

import configureStore from './store/config-store';

import {AsyncStorage} from 'react-native';

const store = configureStore();

export default class Root extends Component {

    render() {

        return (
            <Provider store={store}>
                <Main/>
            </Provider>
        );
    };
};

module.exports = Root;

