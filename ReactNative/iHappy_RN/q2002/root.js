/**
 * Created by zhengda on 16/10/26.
 */


import React, {Component} from 'react';


import {Provider} from 'react-redux';
import configureStore from './stores/config-store';

import MovieListContainer from './containers/MovieListContainer';

var DomParser = require('react-native-html-parser').DOMParser;


const store = configureStore();
export default class QRoot extends Component {
    render() {
        return (
            <Provider store={store}>
                <MovieListContainer {...this.props} />
            </Provider>
        );

    }
}
