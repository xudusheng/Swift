/**
 * Created by zhengda on 16/10/18.
 */

import React, {Component} from 'react';
import {View} from 'react-native';

import {connect} from 'react-redux';//将我们的页面和action链接起来
import {bindActionCreators} from 'redux';//将要绑定的actions和dispatch绑定到一起
import * as actionCreators from './actions/user';//导入需要绑定的actions

class Root extends Component {

    componentDidMount() {
        // // this.props.state;
        // const {login} = this.props.actions;
        // login();

        this.props.actions.login();
    }

    render() {

        console.log('xxxxxxxxxxxxxxxxxx == ');
        return (
            <View style={{flex: 1, backgroundColor: 'red'}}></View>
        );
    };
};


//根据全局state返回当前页面所需要的信息,（注意以props的形式传递给Login）
function mapStateToProps(state) {
    return {
        state,
    };
};

//返回可以操作store.state的actions,(其实就是我们可以通过actions来调用我们绑定好的一系列方法)
function mapDispatchToProps(dispatch) {
    return {
        actions: bindActionCreators(actionCreators, dispatch)
    };
}

export default connect(mapStateToProps, mapDispatchToProps)(Root);
