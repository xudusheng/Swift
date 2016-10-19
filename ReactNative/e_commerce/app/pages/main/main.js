/**
 * Created by zhengda on 16/10/18.
 */

import React, {Component} from 'react';
import {
    StyleSheet,
    View,
    Text,
    Image,
} from 'react-native';

import {connect} from 'react-redux';//将我们的页面和action链接起来
import {bindActionCreators} from 'redux';//将要绑定的actions和dispatch绑定到一起
import * as actionCreators from '../../actions/user';//导入需要绑定的actions

import TabNavigator from 'react-native-tab-navigator';
import Home from '../home/e.home';
import Shop from '../shop/e.shop';
import Mine from '../mine/e.mine';
import More from '../more/e.more';

class Main extends Component {

    constructor(props) {
        super(props);

        this.state = {
            selectedItem: 0,
        };


    }


    componentDidMount() {
        // // this.props.state;
        const {login} = this.props.actions;
        // login();
        login();

    };

    render() {

        console.log(this.props.info.user);
        return (
            <TabNavigator>
                {/*--首页--*/}
                <TabNavigator.Item
                    title="首页"
                    renderIcon={()=><Image source={{uri: 'icon_tabbar_homepage'}} style={styles.iconImageStyle}/>}
                    renderSelectedIcon={()=><Image source={{uri: 'icon_tabbar_homepage_selected'}}
                                                   style={styles.iconImageStyle}/>}
                    onPress={()=>{this.setState({selectedItem:0})}}
                    selected={this.state.selectedItem == 0}
                >

                    <Home />
                </TabNavigator.Item>

                {/*--商家--*/}
                <TabNavigator.Item
                    title="商家"
                    renderIcon={()=><Image source={{uri: 'icon_tabbar_merchant_normal'}}
                                           style={styles.iconImageStyle}/>}
                    renderSelectedIcon={()=><Image source={{uri: 'icon_tabbar_merchant_selected'}}
                                                   style={styles.iconImageStyle}/>}
                    onPress={()=>{this.setState({selectedItem:1})}}
                    selected={this.state.selectedItem == 1}
                >
                    <Shop/>
                </TabNavigator.Item>

                {/*--我的--*/}
                <TabNavigator.Item
                    title="我的"
                    renderIcon={()=><Image source={{uri: 'icon_tabbar_mine'}} style={styles.iconImageStyle}/>}
                    renderSelectedIcon={()=><Image source={{uri: 'icon_tabbar_mine_selected'}}
                                                   style={styles.iconImageStyle}/>}
                    onPress={()=>{this.setState({selectedItem:2})}}
                    selected={this.state.selectedItem == 2}
                >
                    <Mine/>
                </TabNavigator.Item>

                {/*--更多--*/}
                <TabNavigator.Item
                    title="更多"
                    renderIcon={()=><Image source={{uri: 'icon_tabbar_misc'}} style={styles.iconImageStyle}/>}
                    renderSelectedIcon={()=><Image source={{uri: 'icon_tabbar_misc_selected'}}
                                                   style={styles.iconImageStyle}/>}
                    onPress={()=>{this.setState({selectedItem:3})}}
                    selected={this.state.selectedItem == 3}
                >
                    <More/>
                </TabNavigator.Item>


            </TabNavigator>

        );
    };
}
;

const styles = StyleSheet.create({

        iconImageStyle: {
            width: 30,
            height: 30,
        },
    })
    ;

//根据全局state返回当前页面所需要的信息,（注意以props的形式传递给当前页面）
//使用：this.props.info.user
function mapStateToProps(state) {
    return {
        // userReducer在reducer/index.js中定义
        info: state.userReducer,
    };
};

//返回可以操作store.state的actions,(其实就是我们可以通过actions来调用我们绑定好的一系列方法)
function mapDispatchToProps(dispatch) {
    return {
        actions: bindActionCreators(actionCreators, dispatch)
    };
};

export default connect(mapStateToProps, mapDispatchToProps)(Main);
