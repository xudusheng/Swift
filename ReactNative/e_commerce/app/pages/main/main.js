/**
 * Created by zhengda on 16/10/18.
 */

import React, {Component} from 'react';
import {
    StyleSheet,
    View,
    Text,
    Image,
    Navigator,
    NavigatorIOS,
    StatusBarIOS,
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

        this.navigatorDataList = [
            {
                title: '商家',
                normalImage: 'icon_tabbar_merchant_normal',
                selectedImage: 'icon_tabbar_merchant_selected',
                component: Shop,
            },

            {
                title: '首页',
                normalImage: 'icon_tabbar_homepage',
                selectedImage: 'icon_tabbar_homepage_selected',
                component: Home,
            },


            {
                title: '我的',
                normalImage: 'icon_tabbar_mine',
                selectedImage: 'icon_tabbar_mine_selected',
                component: Mine,
            },

            {
                title: '更多',
                normalImage: 'icon_tabbar_misc',
                selectedImage: 'icon_tabbar_misc_selected',
                component: More,
            },
        ];
    }


    componentDidMount() {
        // // this.props.state;
        const {login} = this.props.actions;
        // login();
        login();

    };

    configTabNavigatorItems() {
        var itemList = [];
        for (var i = 0; i < this.navigatorDataList.length; i++) {
            let navigatorData = this.navigatorDataList[i];
            let index = i;
            let oneItem =
                <TabNavigator.Item
                    key={index}
                    title={navigatorData.title}
                    renderIcon={()=><Image source={{uri: navigatorData.normalImage}} style={styles.iconImageStyle}/>}
                    renderSelectedIcon={()=><Image source={{uri: navigatorData.selectedImage}}
                                                   style={styles.iconImageStyle}/>}
                    onPress={()=> {
                        this.setState({selectedItem: index})
                    }}
                    selected={this.state.selectedItem == index}

                    selectedTitleStyle={styles.selectedTitleStyle}
                >

                    <Navigator
                        initialRoute={{name: navigatorData.title, component: navigatorData.component}}
                        configureScene={()=>Navigator.SceneConfigs.PushFromRight}
                        renderScene={(route, navigator)=> {
                            let Component = route.component;
                            return <Component {...route.passProps} navigator={navigator}/>;
                        }}
                    />
                </TabNavigator.Item>
            itemList.push(oneItem);
        }
        return itemList;
    };

    render() {

        console.log(this.props.info.user);
        return (
            <TabNavigator>
                {this.configTabNavigatorItems()}
            </TabNavigator>
        );
    };

}


const styles = StyleSheet.create({

        iconImageStyle: {
            width: 30,
            height: 30,
        },

        selectedTitleStyle: {
            color: 'orange'
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
