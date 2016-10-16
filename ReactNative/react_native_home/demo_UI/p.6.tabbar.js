/**
 * Created by xudosom on 2016/10/15.
 */
import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    View,
    Text,
    Image,
    TouchableOpacity,
    TabBarIOS,
} from 'react-native';

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5F5F5',
    },
    commonViewStyle: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',

    },
});

var PTabBar = React.createClass({
    getDefaultProps(){
        return {
            tabBarInfos: [
                {
                    'title': 'bookmarks',
                    'icon': 'bookmarks',
                    'badge': '3',
                    'color': 'red',
                    // 'view':<View />,//这里可以添加自定义的view,或者在这里设置ref
                },
                {
                    'title': 'contacts',
                    'icon': 'contacts',
                    'badge': '0',
                    'color': 'blue',
                },
                {
                    'title': 'downloads',
                    'icon': 'downloads',
                    'badge': '1',
                    'color': 'green',
                },
                {
                    'title': 'more',
                    'icon': 'more',
                    'badge': '2',
                    'color': 'yellow',
                }]
        }
    },

    getInitialState(){
        return {
            selectedTabBarItem: 'bookmarks',
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
            let title = tabbarInfo.title;//这里一定要用let，不能是var
            items.push(
                <TabBarIOS.Item
                    key={tabbarInfo.title}
                    systemIcon={tabbarInfo.icon}
                    selected={this.state.selectedTabBarItem == title}
                    onPress={() => {
                        console.log('xxxxxxxxxxxxx == ' + tabbarInfo.title + '===' + i);
                        console.log('xxxxxxxxxxxxx == ' + this.state.selectedTabBarItem);
                        this.setState({selectedTabBarItem: title})
                    }}
                    badge={tabbarInfo.badge}>
                    <View style={[styles.commonViewStyle, {backgroundColor: tabbarInfo.color}]}>
                        {console.log('wwwwwwwww == ' + tabbarInfo.title)}
                        <Text>{tabbarInfo.title}</Text>
                    </View>
                </TabBarIOS.Item>
            );
        }
        return items;
    },

});

module.exports = PTabBar;