/**
 * Created by xudosom on 2016/10/15.
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    View,
    Text,
    TabBarIOS,
    NavigatorIOS,
} from 'react-native';


var PNewsHome = require('./p.news.home');
var PNewsFind = require('./p.news.find');
var PNewsMessage = require('./p.news.message');
var PNewsMe = require('./p.news.me');

var PNewsMain = React.createClass({
    getDefaultProps(){
        let homeNav = <NavigatorIOS
            tintColor='brown'
            style={{flex: 1,}}
            initialRoute={{
                component: PNewsHome,
                title: '首页',
                leftButtonIcon:{uri:'navigationbar_friendattention', scale:2},
                rightButtonIcon:{uri:'navigationbar_pop_highlighted',scale:2},

            }}/>

        let findNav = <NavigatorIOS
            style={{flex: 1,}}
            initialRoute={{
                component: PNewsFind,
                title: '发现'
            }}/>

        let messageNav = <NavigatorIOS
            style={{flex: 1,}}
            initialRoute={{
                component: PNewsMessage,
                title: '消息'
            }}/>

        let meNav = <NavigatorIOS
            style={{flex: 1,}}
            initialRoute={{
                component: PNewsMe,
                title: '我的'
            }}/>
        {console.log(homeNav.props.initialRoute.title)}

        return {
            tabBarInfos: [
                {
                    'title': homeNav.props.initialRoute.title,
                    'icon': 'tabbar_home',
                    'highlighted': 'tabbar_home_highlighted',
                    'view': homeNav,
                },
                {
                    'title': findNav.props.initialRoute.title,
                    'icon': 'tabbar_discover',
                    'highlighted': 'tabbar_discover_highlighted',
                    'view': findNav,
                },
                {
                    'title': messageNav.props.initialRoute.title,
                    'icon': 'tabbar_message_center',
                    'highlighted': 'tabbar_message_center_highlighted',
                    'view': messageNav,
                },
                {
                    'title': meNav.props.initialRoute.title,
                    'icon': 'tabbar_profile',
                    'highlighted': 'tabbar_profile_highlighted',
                    'view': meNav,
                }
            ],
        };
    },

    getInitialState(){
        return {
            selectedTabBarItem: 0,
        };
    },

    render(){
        return (
            <View style={styles.container}>
                <TabBarIOS>
                    {this.renderTabBarItems()}
                </TabBarIOS>
            </View>
        );
    },

    renderTabBarItems(){
        var items = [];
        for (var i = 0; i < this.props.tabBarInfos.length; i++) {
            let tabbarInfo = this.props.tabBarInfos[i];//这里一定要用let，不能是var
            let itemIndex = i;
            items.push(
                <TabBarIOS.Item
                    tineColor='red'
                    key={itemIndex}
                    icon={{uri: tabbarInfo.icon, scale: 2}}
                    selectedIcon={{uri: tabbarInfo.highlighted, scale: 2}}
                    title={tabbarInfo.title}
                    selected={this.state.selectedTabBarItem == itemIndex}
                    onPress={() => {
                        this.setState({selectedTabBarItem: itemIndex})
                    }}
                    badge={tabbarInfo.badge}>

                    {tabbarInfo.view}

                </TabBarIOS.Item>
            );
        }
        return items;
    },


});

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5F5F5',
    },

});

module.exports = PNewsMain;