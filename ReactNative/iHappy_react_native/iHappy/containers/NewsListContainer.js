/**
 * Created by Hmily on 2016/11/28.
 */


import React, {Component} from 'react';
import {connect} from 'react-redux';
import {bindActionCreators} from 'redux';
import NewsListView from '../pages/NewsList';
import * as NewsCreators from '../actions/news';

class NewsListContainer extends Component {
    componentDidMount() {
        //版本检查

    }

    render(){
        return (
            //容器接收action和state，并将这两个参数传递给NewsListView
            <NewsListView {...this.props}/>
        );
    }

}

//根据全局state返回当前页面所需要的信息,（注意以props的形式传递给当前页面）
//使用：this.props.news
function mapStateToProps(state) {
    return {
        // movieReducer在reducer/index.js中定义
        news: state.news,
    };
}

//返回可以操作store.state的actions,(其实就是我们可以通过actions来调用我们绑定好的一系列方法)
function mapDispatchToProps(dispatch) {
    return {
        actions: bindActionCreators(NewsCreators, dispatch)
    };
}

export default connect(mapStateToProps, mapDispatchToProps)(NewsListContainer);