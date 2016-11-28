/**
 * Created by Hmily on 2016/11/28.
 */

import React, {Component} from 'react';


import {Provider} from 'react-redux';
import configureStore from './iHappy/stores/config-store';

import Main from './Main';


const store = configureStore();
export default class Root extends Component {
    render() {
        return (
            <Provider store={store}>
                <Main {...this.props} />
            </Provider>
        );

    }
}