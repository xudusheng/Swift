/**
 * Created by zhengda on 16/10/31.
 */

import React from 'react';
import {
    Navigator,
}from 'react-native';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import QHome from '../pages/MovieList';
import * as movieCreators from '../actions/movie';

class MovieListContainer extends React.Component {
    static componentDidMount() {
        //检查更新
    }

    render() {
        return (
            <Navigator
                initialRoute={{name: '首页', component: QHome}}
                configureScene={()=>Navigator.SceneConfigs.PushFromRight}
                renderScene={(route, navigator)=> {
                    let Component = route.component;
                    return <Component {...route.passProps} {...this.props} navigator={navigator}/>;
                }}
            />

        );
    }
}

//根据全局state返回当前页面所需要的信息,（注意以props的形式传递给当前页面）
//使用：this.props.movie
function mapStateToProps(state) {
    return {
        // movieReducer在reducer/index.js中定义
        movie: state.movieReducer,
    };
}

//返回可以操作store.state的actions,(其实就是我们可以通过actions来调用我们绑定好的一系列方法)
function mapDispatchToProps(dispatch) {
    return {
        actions: bindActionCreators(movieCreators, dispatch)
    };
}

export default connect(mapStateToProps, mapDispatchToProps)(MovieListContainer);